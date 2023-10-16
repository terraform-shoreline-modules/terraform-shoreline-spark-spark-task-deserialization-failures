resource "shoreline_notebook" "spark_task_deserialization_failures" {
  name       = "spark_task_deserialization_failures"
  data       = file("${path.module}/data/spark_task_deserialization_failures.json")
  depends_on = [shoreline_action.invoke_check_spark_deser_compat,shoreline_action.invoke_install_deserialization_library]
}

resource "shoreline_file" "check_spark_deser_compat" {
  name             = "check_spark_deser_compat"
  input_file       = "${path.module}/data/check_spark_deser_compat.sh"
  md5              = filemd5("${path.module}/data/check_spark_deser_compat.sh")
  description      = "Incompatibility between the Spark version and the serialization/deserialization library used for the job."
  destination_path = "/tmp/check_spark_deser_compat.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "install_deserialization_library" {
  name             = "install_deserialization_library"
  input_file       = "${path.module}/data/install_deserialization_library.sh"
  md5              = filemd5("${path.module}/data/install_deserialization_library.sh")
  description      = "Update the deserialization library to one that's compatible with the Spark version"
  destination_path = "/tmp/install_deserialization_library.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_spark_deser_compat" {
  name        = "invoke_check_spark_deser_compat"
  description = "Incompatibility between the Spark version and the serialization/deserialization library used for the job."
  command     = "`chmod +x /tmp/check_spark_deser_compat.sh && /tmp/check_spark_deser_compat.sh`"
  params      = []
  file_deps   = ["check_spark_deser_compat"]
  enabled     = true
  depends_on  = [shoreline_file.check_spark_deser_compat]
}

resource "shoreline_action" "invoke_install_deserialization_library" {
  name        = "invoke_install_deserialization_library"
  description = "Update the deserialization library to one that's compatible with the Spark version"
  command     = "`chmod +x /tmp/install_deserialization_library.sh && /tmp/install_deserialization_library.sh`"
  params      = ["NEW_DESERIALIZATION_LIBRARY","SPARK_VERSION"]
  file_deps   = ["install_deserialization_library"]
  enabled     = true
  depends_on  = [shoreline_file.install_deserialization_library]
}

