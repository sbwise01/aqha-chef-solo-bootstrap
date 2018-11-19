name "default"
description "Default test role for aqha-chef-solo-bootstrap testing"

run_list(
  "recipe[aqha-chef-solo-bootstrap::default]"
)

default_attributes(
  "aqha" => {
    "role_name" => "fooRoleName",
    "environment_name" => "fooEnvironmentName"
  }
)
