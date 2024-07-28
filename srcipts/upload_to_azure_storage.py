from azure.storage.blob import ContainerClient, ContentSettings
import os
from pathlib import Path
from tqdm import tqdm


container_client = ContainerClient(
    account_url="https://www233.blob.core.windows.net/chiikawa-item-images?sp=racw&st=2024-07-27T15:19:51Z&se=2024-07-27T23:19:51Z&spr=https&sv=2022-11-02&sr=c&***REMOVED***",
    container_name="chiikawa-item-images",
)


def upload_blob_file_stream(file_path: Path):

    content_type = "image/jpeg" if file_path.suffix == ".jpg" else "image/png"
    content_settings = ContentSettings(
        content_type=content_type, content_disposition="inline"
    )

    try:
        with file_path.open(mode="rb") as data:
            blob_client = container_client.upload_blob(
                name=file_path.name,
                data=data,
                blob_type="BlockBlob",
                overwrite=True,
            )
        return True
    except Exception as e:
        print(e)
        return False


def update_blob_properties(file_path: Path):
    try:
        blob_client = container_client.get_blob_client(file_path.name)
        content_type = "image/jpeg" if file_path.suffix == ".jpg" else "image/png"
        content_settings = ContentSettings(
            content_type=content_type, content_disposition="inline"
        )

        # 设置Blob的属性
        blob_client.set_http_headers(content_settings)
        return True
    except Exception as e:
        print(e)
        return False


if __name__ == "__main__":
    for path in tqdm(Path("static/images").iterdir()):
        # upload_blob_file_stream(path)
        update_blob_properties(path)
