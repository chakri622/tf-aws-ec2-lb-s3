# aws s3 bucket 
resource "aws_s3_bucket" "web_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = var.common_tags
}

#aws s3 bucket policy
resource "aws_s3_bucket_policy" "web_bucket" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = <<POLICY
{
       "Version": "2012-10-17",
       "Statement": [
         
          {

             "Effect": "Allow",     

             "Action": "s3:PutObject",
             "Principal": {
                "AWS": ["${var.elb_service_account_arn}"]
            },
           
             "Resource": "arn:aws:s3:::${var.bucket_name}/alb-logs/*",
             "Condition": {
              "StringEquals": {
                "s3:x-amz-acl": "bucket-owner-full-control"
              }
             }
          },
         
          {         

            "Effect": "Allow",               

                "Action": "s3:GetBucketAcl",      
                "Principal": {
                    "AWS": ["${var.elb_service_account_arn}"]
                } ,
                "Resource": "arn:aws:s3:::${var.bucket_name}"
          }



        ]
}

    POLICY

}




#aws_iam_role
resource "aws_iam_role" "allow_nginx_s3" {
  name               = "allow_nginx_s3"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            }
        }
    ]
}
EOF
  tags               = var.common_tags
}

# aws_iam_instance_profile
resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name
  tags = var.common_tags

}

#aws_iam_role_policy

resource "aws_iam_role_policy" "allow_nginx_s3_policy" {
  name   = "allow_nginx_s3_policy"
  role   = aws_iam_role.allow_nginx_s3.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Action": [
                    "s3:*"
                ],
                "Resource": [
                    "arn:aws:s3:::${var.bucket_name}",
                    "arn:aws:s3:::${var.bucket_name}/*"
                ]
            }
        ]
}
EOF
}



