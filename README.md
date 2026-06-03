### Passing varibales based onthe environment through .fvars
```
    terraform plan -var-file=uat.tfvars
    terraform apply -var-file=uat.tfvars
```

### If you want to destroy the module you can use this below commands
# # # List of terraform modules that you want to delete
```bash
terraform state list

output:-
    module.igw.aws_internet_gateway.arka-dev
    module.keypair.aws_key_pair.this
    module.keypair.local_file.private_key
    module.keypair.tls_private_key.this
    module.public_rt.aws_route_table.public[0]
    module.public_rt.aws_route_table_association.arka-dev[0]
    module.public_subnet.aws_subnet.arka-dev[0]
    module.security_groups["app"].aws_security_group.arka-dev
    module.security_groups["bastion"].aws_security_group.arka-dev
    module.vpc.aws_vpc.arka-dev
```

# # # Execute the below command to destroy
# To Destroy Multiple modules at a time
```bash
    terraform destroy -target=module.appserver,module.webserver
```
# To Destroy Single module
```bash
    terraform destroy -target=module.appserver
```
### If you want to re-deploy the module
```bash
    terraform apply -replace="module.appserver.aws_instance.this"
```
