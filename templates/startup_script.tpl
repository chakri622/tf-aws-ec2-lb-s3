#!/bin/bash

  sudo amazon-linux-extras install nginx1
  sudo service nginx start
  aws s3 cp s3://${s3_bucket_name}/website/index.html /home/ec2-user/index.html
  sudo rm /usr/share/nginx/html/index.html
  sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
