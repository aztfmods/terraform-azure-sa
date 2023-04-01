package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestApplyNoError(t *testing.T) {
	t.Parallel()

	tests := map[string]string{
		"shares":              "../examples/shares",
		"blob":                "../examples/blob",
		"simple":              "../examples/simple",
		"management-policies": "../examples/management-policies",
		"containers":          "../examples/containers",
		"diagnostic-settings": "../examples/diagnostic-settings",
	}

	for name, path := range tests {
		t.Run(name, func(t *testing.T) {
			terraformOptions := &terraform.Options{
				TerraformDir: path,
				NoColor:      true,
			}

			terraform.WithDefaultRetryableErrors(t, &terraform.Options{})

			defer terraform.Destroy(t, terraformOptions)
			terraform.InitAndApply(t, terraformOptions)
		})
	}
}
