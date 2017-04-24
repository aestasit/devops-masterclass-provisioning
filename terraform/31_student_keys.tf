
resource "aws_iam_user" "student" {
  count = "${var.student_count}"
  name = "student${format("%02d", count.index + 1)}"
  force_destroy = true
}

resource "aws_iam_access_key" "student_key" {
  count = "${var.student_count}"
  user = "${element(aws_iam_user.student.*.name, count.index)}"
}

resource "aws_iam_user_policy" "student_policy" {
  count = "${var.student_count}"
  name = "student${format("%02d", count.index + 1)}"
  user = "${element(aws_iam_user.student.*.name, count.index)}"
  policy = "${file("student.policy")}"
}
