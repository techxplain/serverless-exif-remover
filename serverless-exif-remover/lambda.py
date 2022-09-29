import urllib.parse
import boto3
from os import environ
from io import BytesIO
from PIL import Image


def handler(event, context):
    s3 = boto3.client('s3')
    dest_bucket = environ["bucketB"]
    # object to receive data from s3.download_obj rather than writing to a file
    image_data = BytesIO()
    # object to write new image file to
    new_image = BytesIO()

    # Get the names of the s3 bucket and the object
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')

    try:
        # Download the image into the image_data object
        s3.download_fileobj(Bucket=source_bucket, Key=key, Fileobj=image_data)
        print(f"Got object {key} from {source_bucket}")
    except Exception as e:
        print(e)
        print(f'Error getting object {key} from bucket {source_bucket}.')
        raise e

    # Open image in Pillow, this will also clear the EXIF data. Save it to new file object
    Image.open(image_data).save(fp=new_image, format='jpeg')

    try:
        # Send image to S3 bucket B
        put_response = s3.put_object(Bucket=dest_bucket, Key=key, Body=new_image.getvalue())
        print(f"Put {key} into {dest_bucket}")
        return put_response
    except Exception as e:
        print(e)
        print(f'Error putting object {key} into bucket {dest_bucket}.')
        raise e
