name "default"
description "Default test role for aqha-chef-solo-bootstrap testing"

run_list(
  "recipe[aqha-chef-solo-bootstrap::default]"
)

default_attributes(
  "aqha" => {
    "bootstrap_role_name" => "fooRoleName",
    "bootstrap_environment_name" => "fooEnvironmentName"
  }
)
