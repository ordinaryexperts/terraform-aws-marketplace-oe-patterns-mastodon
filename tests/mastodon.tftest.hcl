provider "aws" {
  region  = "us-east-1"
}

run "setup_tests" {
    module {
        source = "./tests/setup"
    }
}

run "provision_mastodon" {
  command = apply

  variables {
    alb_certificate_arn = "arn:aws:acm:us-east-1:343218188409:certificate/ef859721-e16e-4fcd-9d10-8dfb188bd15a"
    alb_ingress_cidr = "0.0.0.0/0"
    dns_hostname = "${run.setup_tests.stack_prefix}-mastodon-test.test.patterns.ordinaryexperts.com"
    dns_route53_hosted_zone_name = "test.patterns.ordinaryexperts.com"
    # role already exists in test account
    open_search_service_create_service_linked_role = false
    # domain identity already exists in test account
    ses_create_domain_identity = false
    stack_name = "${run.setup_tests.stack_prefix}-mastodon-test"
  }

  # Check that the DNS Site URL output is correct
  assert {
    condition     = output.dns_site_url_output ==  "https://${run.setup_tests.stack_prefix}-mastodon-test.test.patterns.ordinaryexperts.com"
    error_message = "Invalid DNS Site URL output"
  }
}
