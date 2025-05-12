resource "local_file" "openapi_template" {
  filename = "${path.module}/openapi/generated-openapi-definition.json"

  content = templatefile("${path.module}/openapi/tech-challenge-api-definition.json", {
    lb_dns_name            = data.aws_lb.nlb.dns_name
    vpc_link_id            = aws_api_gateway_vpc_link.vpc_link.id
    authorizer_credentials = data.aws_iam_role.lab_role.arn
  })
}

resource "aws_api_gateway_rest_api" "web_api" {
  name = "tech-challenge-api"

  body = local_file.openapi_template.content

  binary_media_types = ["*/*"]

  depends_on = [local_file.openapi_template]
}

resource "aws_api_gateway_deployment" "web_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.web_api.id

  triggers = {
    redeploy = sha1(local_file.openapi_template.content)
  }

  depends_on = [aws_api_gateway_rest_api.web_api]
}

resource "aws_api_gateway_stage" "web_api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.web_api.id
  deployment_id = aws_api_gateway_deployment.web_api_deployment.id
  stage_name    = "techchallenge"

  depends_on = [aws_api_gateway_deployment.web_api_deployment]
}