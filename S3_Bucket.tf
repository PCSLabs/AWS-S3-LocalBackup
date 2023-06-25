resource "aws_s3_bucket" "local_backup" {
  bucket = "mau-local-backup"
  tags = {
      Name        = "My bucket"
      Environment = "Dev"
    }
}

resource "aws_s3_access_point" "local_backup_ap" {
  bucket = aws_s3_bucket.local_backup.id
  name   = "local-backup-ap"

  public_access_block_configuration {
      block_public_acls       = true
      block_public_policy     = false
      ignore_public_acls      = true
      restrict_public_buckets = false
    }

    lifecycle {
      ignore_changes = [policy]
    }

    provisioner "local-exec" {
      command = "echo 'ARN = ${aws_s3_access_point.local_backup_ap.arn}' > ./ap_arn.txt"
    }
}

  resource "aws_s3control_access_point_policy" "ap_policy" {
    access_point_arn = aws_s3_access_point.local_backup_ap.arn

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
            Effect = "Allow",
            Principal = {
                "AWS": "arn:aws:iam::251673795712:user/system/LocalBackup"
            },
            Action = [
                "s3:PutObject",
                "s3:GetObject"
            ],
            Resource = "arn:aws:s3:us-west-2:251673795712:accesspoint/local-backup-ap/object/*"
        }
    ]
  })

  depends_on = [
      aws_s3_bucket.local_backup,
      aws_s3_access_point.local_backup_ap,
      aws_iam_user.local_backup
  ]
}
