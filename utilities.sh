#!/bin/bash

# Function to add CNAME record to Route53 hosted zone
add_cname_record() {
    # Variables
    HOSTED_ZONE_ID="Z06434181KVJ88LDEYYII"
    RECORD_NAME="$1"
    CNAME_VALUE="$2"
    echo "the record named is $RECORD_NAME "
    echo "the CNAME named is $CNAME_VALUE "
    # Check if the record already exists
    RECORD_DOT="${RECORD_NAME}."
    existing_record=$(aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --query "ResourceRecordSets[?Name == '$RECORD_DOT'].Name" --output text)
    if [[ "$existing_record" == "$RECORD_DOT" ]]; then
        echo "The record '$RECORD_NAME' already exists."
        exit 1
    fi

    # Add the CNAME record
    aws route53 change-resource-record-sets \
        --hosted-zone-id $HOSTED_ZONE_ID \
        --change-batch "{
            \"Changes\": [
                {
                    \"Action\": \"CREATE\",
                    \"ResourceRecordSet\": {
                        \"Name\": \"$RECORD_NAME\",
                        \"Type\": \"CNAME\",
                        \"TTL\": 3600,
                        \"ResourceRecords\": [
                            {
                                \"Value\": \"$CNAME_VALUE\"
                            }
                        ]
                    }
                }
            ]
        }"

    echo "CNAME record '$RECORD_NAME' added successfully."
}

delete_cname_record() {
    # Variables
    HOSTED_ZONE_ID="Z06434181KVJ88LDEYYII"
    RECORD_NAME="$1"
    CNAME_VALUE="$2"
    RECORD_DOT="${RECORD_NAME}."

    # Check if the record exists
    existing_record=$(aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --query "ResourceRecordSets[?Name == '$RECORD_DOT'].Name" --output text)
    if [[ "$existing_record" == "$RECORD_DOT" ]]; then
        # Delete the CNAME record
        aws route53 change-resource-record-sets \
            --hosted-zone-id $HOSTED_ZONE_ID \
            --change-batch "{
            \"Changes\": [
                {
                    \"Action\": \"DELETE\",
                    \"ResourceRecordSet\": {
                        \"Name\": \"$RECORD_NAME\",
                        \"Type\": \"CNAME\",
                        \"TTL\": 3600,
                        \"ResourceRecords\": [
                            {
                                \"Value\": \"$CNAME_VALUE\"
                            }
                        ]
                    }
                }
            ]
        }"

        echo "CNAME record '$RECORD_NAME' deleted successfully."
    else
        echo "The record '$RECORD_NAME' does not exist."
    fi
}


"$@"
