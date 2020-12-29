output "hostname_record" {
  value  = [ 
    for hostname, value in zipmap(
    values(cloudflare_record.records)[*].hostname, 
    values(cloudflare_record.records)[*].value)
    : map("hostname", hostname, "value", value)
  ]
}
