
resource "aws_iam_user_policy" "local_backup_policy" {
  name = "local_backup_policy"
  user = var.username

policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
    {
    "Sid": "AllObjectActions",
    "Effect": "Allow",
    "Action": "s3:*Object",
    "Resource": [
      "arn:aws:s3:::mau-local-backup/*",
      "arn:aws:s3:::mau-local-backup"      ]
    }
	]
})
  depends_on = [
      aws_iam_user.local_backup
  ]
}
