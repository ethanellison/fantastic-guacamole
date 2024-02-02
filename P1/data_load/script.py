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

# TODO function to lookup valid team names in xata.io database


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
        "url": "https://data04.perfbook.pro/_DATA/volleyball/2024/file_f900c9373826224ae7a24d4185135d780e85682b0bf72619.dvw",
        "match_date": "2024-01-26",
    },
    {
        "url": "https://data04.perfbook.pro/scripts/download.php?id=JjIwMjQwMTI3XzE0MDM3X2NhcmFiaW5zLWxhdmFsXzMtMi5kdnd8fGh0dHBzOi8vZGF0YTA0LnBlcmZib29rLnByby9fREFUQS92b2xsZXliYWxsLzIwMjQvZmlsZV9hMmZhZmY5ODQ0MDdlMzY3MjliYmZkYTI4Y2E5ZWFkNTcwNmJkMzZhODhiMTAxMDMuZHZ3",
        "match_date": "2024-01-27",
    },
    {
        "url": "https://data04.perfbook.pro/_DATA/volleyball/2024/file_f7d7b82a4c5ad78980a315cc6be41a410c9c4a9088b11314.dvw",
        "match_date": "2024-01-27",
    },
]

for item in items:
    output = process_to_df(item["url"], item["match_date"])
    print(output[0], output[1])
    print(
        object_storage.put_object(
            namespace_name=namespace,
            bucket_name=bucket_name,
            object_name=output[1],
            put_object_body=output[0].to_csv(index=False),
            content_type="text/csv",
        ).data
    )
