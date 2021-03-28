terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
#iam group that created user is associated with iam user.
resource "aws_iam_group" "ec2-mods" {
  name = "ec2-mods"
  path = "/users/"
}
#creates an iam user. repeat code to make another user.
resource "aws_iam_user" "ec2-alpha" {
  name = "ec2-alpha"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_access_key" "ec2-alpha" {
  user = aws_iam_user.ec2-alpha.name
}
data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
#creates user password. repeat code for another user.
resource "aws_iam_user_login_profile" "ec2-alpha" {
  user            = aws_iam_user.ec2-alpha.name
  password_length = 10
  pgp_key         = "keybase:kieldemarco"
}
resource "local_file" "ec2-alpha_password" {
  sensitive_content = "-----BEGIN PGP MESSAGE-----\nComment: https://keybase.io/download\nVersion: Keybase Go 1.0.10 (linux)\n\n${aws_iam_user_login_profile.ec2-alpha.encrypted_password}\n-----END PGP MESSAGE-----\n"
  filename          = "encrypted_password.ec2-alpha.txt"
  file_permission   = "0600"
}

