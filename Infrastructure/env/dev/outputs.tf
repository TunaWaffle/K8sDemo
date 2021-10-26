output "sql_server_admin_password" {
    value     = module.env.sql_server.administrator_login_password
    sensitive = true
}

output "sql_server_admin_login" {
    value     = module.env.sql_server.administrator_login
    sensitive = true
}