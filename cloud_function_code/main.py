from os import environ

from google.cloud import storage


def update_cache_control(event, context) -> None:
    """Triggered by a change to a Cloud Storage bucket.
    Args:
         event (dict): Event payload.
         context (google.cloud.functions.Context): Metadata for the event.
    """
    cache_max_age = environ.get('CACHE_MAX_AGE', 30)
    bucket_name = event['bucket']
    object_name = event['name']

    # Instantiates a client
    storage_client = storage.Client()
    bucket = storage_client.get_bucket(bucket_name)
    blob = bucket.get_blob(object_name)

    # Update object's Cache-Control metadata
    print(f"Processing object: {object_name}")
    cache_control_settings = f'public, max-age={cache_max_age}'
    blob.cache_control = cache_control_settings
    blob.patch()
    print(f"Object's Cache-Control metadata updated: {cache_control_settings}")
