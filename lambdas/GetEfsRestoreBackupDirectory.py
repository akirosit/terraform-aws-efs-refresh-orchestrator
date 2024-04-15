import boto3
import json
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):

    #awsregion = os.environ["AWS_REGION"]
    #efsclient = boto3.client("efs", region_name=awsregion)
    
    try:
        items = os.listdir('/mnt/efs/')
        backup_dir_items = []
        for item in items:
            logger.info("Item {} isdir {}".format(item,os.path.isdir(item)))
            if item.startswith("aws-backup-restore_"):
                backup_dir_items.append(item)
    except FileNotFoundError as error:
        logger.error(str(error))
        raise FileNotFoundError("EFS not found")
    except Exception as error:
        logger.info("Scripts run with errors. Unknow error")
        logger.error(str(error))
        raise ValueError("Scripts run with errors. Unknow error:", str(error))
    if len(backup_dir_items) > 1:
        raise ValueError("Scripts run with errors. Multiple backup directories:", str(backup_dir_items))

    return {"statusCode": 200, "body": json.dumps(backup_dir_items)}