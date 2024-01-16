import oci
import rpy2
from rpy2.robjects.packages import importr
import subprocess
import rpy2.robjects as ro
from rpy2.robjects import pandas2ri

default_config = oci.config.from_file()
oci.config.validate_config(default_config)
object_storage = oci.object_storage.ObjectStorageClient(default_config)
namespace = "axpq19bjme6h"
compartment = "ocid1.compartment.oc1..aaaaaaaaaeo2cybel663xmrolt55ohpc3zwu7myyhgvjj5vo6nvuxso6g2dq"
bucket_name = object_storage.list_buckets(namespace, compartment).data[0].name


base = importr("base")
utils = importr("utils")
utils.chooseCRANmirror(ind=1)  # select the first mirror in the list


datavolley = importr("datavolley")
ovlytics = importr("ovlytics")


def replace_NA(x):
    if x == rpy2.rinterface_lib.na_values.NA_Character:
        return None
    return x


def curl_command(url):
    cmd = f"curl --insecure {url} -o ./dvw/match.dvw"
    subprocess.check_output(cmd, shell=True, text=True)


def process_to_df(url, match_date):
    curl_command(url)
    x = datavolley.dv_read(
        "dvw/match.dvw",
        insert_technical_timeouts=False,
        extra_validation=1,
        do_transliterate=False,
    )
    x_augmented = ovlytics.ov_augment_plays(
        datavolley.plays(x), to_add="all", rotation="SHM", use_existing=False
    )
    teams = datavolley.teams(x)
    raw_sum = "pb-" + match_date + base.paste(teams, collapse="-")[0] + ".csv"
    with (ro.default_converter + pandas2ri.converter).context():
        df = ro.conversion.get_conversion().rpy2py(x_augmented)
    df = df.map(lambda x: replace_NA(x))

    return (df, raw_sum)


items = [
    {
        "url": "https://data04.perfbook.pro/scripts/download.php?id=JjIwMjQwMTEyXzEzODI1X2RhbGhvdXNlLXNoZXJicm9va2VfMC0zLmR2d3x8aHR0cHM6Ly9kYXRhMDQucGVyZmJvb2sucHJvL19EQVRBL3ZvbGxleWJhbGwvMjAyNC9maWxlXzI1OGMwYjgxNmI0ZWMwNjUxNTcyMTU0MzMzM2RmZGUzMTgyNTA0N2I5Y2I0NDAyMC5kdnc=",
        "match_date": "2024-01-12",
    },
    {
        "url": "https://data04.perfbook.pro/scripts/download.php?id=JjEzODMzX01MQVZBTC1NVU5CIFJFRFMuZHZ3fHxodHRwczovL2RhdGEwNC5wZXJmYm9vay5wcm8vX0RBVEEvdm9sbGV5YmFsbC8yMDI0L2ZpbGVfMThjMjA4YmM2NWQ1NTQ2YWE5NGI4MWRlZmUwOWZhMGIwYWUwZjY4NTljYjQwMDI4LmR2dw==",
        "match_date": "2024-01-12",
    },
    {
        "url": "https://data04.perfbook.pro/scripts/download.php?id=JjEzODUzIE1EQUxIT1VJU0UtTVNIRVJCUk9PS0UgMC5kdnd8fGh0dHBzOi8vZGF0YTA0LnBlcmZib29rLnByby9fREFUQS92b2xsZXliYWxsLzIwMjQvZmlsZV9lNThkMDMxZGI5OTY4YzEzZTI1YmQ0ZmM3YTc4NjM1N2Q0MzNhYzMwOTRiZjM0NTMuZHZ3",
        "match_date": "2024-01-13",
    },
    {
        "url": "https://data04.perfbook.pro/scripts/download.php?id=JjIwMjQwMTEzXzEzODM3X2xhdmFsIHJvdWdlIG0tdW5iXzAtMy5kdnd8fGh0dHBzOi8vZGF0YTA0LnBlcmZib29rLnByby9fREFUQS92b2xsZXliYWxsLzIwMjQvZmlsZV84NjVlMzQ2NGNhOTg3ZDdkOTlmNGMwNGQ5NzUwMTRkNWRkNjFmODFlOTRiZjI4NDguZHZ3",
        "match_date": "2024-01-13",
    },
]

for item in items:
    output = process_to_df(item["url"], item["match_date"])
    print(
        object_storage.put_object(
            namespace_name=namespace,
            bucket_name=bucket_name,
            object_name=output[1],
            put_object_body=output[0].to_csv(index=False),
            content_type="text/csv",
        ).data
    )
