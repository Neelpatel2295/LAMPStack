resource "aws_s3_bucket" "lampbucketlaravel" {
  bucket = "lampbucketlaravel"

  versioning {
    enabled = true
  }
  lifecycle {
		prevent_destroy = true
	}
  }
resource "aws_iam_role" "role" {
  name = "role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17", 
  "Statement": [
    {
      "Action": "sts:AssumeRole", 
      "Effect": "Allow", 
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
   ]
} 
EOF
}
resource "aws_iam_policy" "S3policy" {
  name = "S3policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
				"arn:aws:s3:::lampbucketlaravel/*",
                "arn:aws:s3:::lampbucketlaravel"
            ]
        }
    ]
}
  EOF
}
resource "aws_iam_role_policy_attachment" "attachingpolicy" {
    role       = "${aws_iam_role.role.name}"
    policy_arn = "${aws_iam_policy.S3policy.arn}"
}

resource "aws_iam_instance_profile" "instanceprofile" {
  name  = "instanceprofile"
  roles = ["${aws_iam_role.role.name}"]
}