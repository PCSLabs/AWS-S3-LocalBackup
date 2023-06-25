resource "aws_iam_user" "local_backup" {
  name = var.username
  path = "/system/"

  tags = {
    tag-key = "local_backup"

  }
}

resource "aws_iam_access_key" "local_backup" {
  user = var.username

  provisioner "local-exec" {
    command = "echo 'secret = ${aws_iam_access_key.local_backup.secret}' , id = '${aws_iam_access_key.local_backup.id}' > ./access_key.txt"
  }

  depends_on = [
      aws_iam_user.local_backup
    ]
}
