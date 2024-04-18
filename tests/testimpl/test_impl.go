package testimpl

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cloudfront"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	awsClient := GetAWSCloudFrontClient(t)

	t.Run("TestCloudFrontDistributionExists", func(t *testing.T) {
		awsCloudFrontDistributionId := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_id")
		awsCloudFrontDistributionArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_arn")
		awsCloudFrontDistributionStatus := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_status")
		awsCloudFrontDistributionDomainName := terraform.Output(t, ctx.TerratestTerraformOptions(), "cloudfront_distribution_domain_name")

		awsCloudFrontDistribution, err := awsClient.GetDistribution(context.TODO(), &cloudfront.GetDistributionInput{
			Id: &awsCloudFrontDistributionId,
		})
		if err != nil {
			t.Errorf("Failure during GetDistribution: %v", err)
		}

		assert.Equal(t, *awsCloudFrontDistribution.Distribution.Id, awsCloudFrontDistributionId, "Expected ID did not match actual ID!")
		assert.Equal(t, *awsCloudFrontDistribution.Distribution.ARN, awsCloudFrontDistributionArn, "Expected ARN did not match actual ARN!")
		assert.Equal(t, *awsCloudFrontDistribution.Distribution.DomainName, awsCloudFrontDistributionDomainName, "Expected Domain Name did not match actual Domain Name!")
		assert.Equal(t, *awsCloudFrontDistribution.Distribution.Status, awsCloudFrontDistributionStatus, "Expected Status did not match actual Status!")
	})
}

func GetAWSCloudFrontClient(t *testing.T) *cloudfront.Client {
	awsCloudFrontClient := cloudfront.NewFromConfig(GetAWSConfig(t))
	return awsCloudFrontClient
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
