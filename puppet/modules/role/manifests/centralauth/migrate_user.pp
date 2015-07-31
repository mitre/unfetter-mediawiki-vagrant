# == Define role::centralauth::migrate_user
# Migrate a user account to the central auth database
#
# === Parameters
# [*user*]
#   User to migrate. Default $title
#
# === Example
# role::centralauth::migrate_user { 'Admin': }
#
define role::centralauth::migrate_user(
    $user = $title,
) {
    exec { "migrate_user_${user}_to_centralauth":
        # lint:ignore:80chars
        command => "/usr/local/bin/mwscript extensions/CentralAuth/maintenance/migrateAccount.php --username '${user}' --auto",
        unless  => "/usr/local/bin/mwscript extensions/CentralAuth/maintenance/migrateAccount.php --username '${user}' | /bin/grep -q 'already exists'",
        # lint:endignore
        user    => 'www-data',
        require => [
            Class['::mediawiki::multiwiki'],
            Mysql::Sql['Create CentralAuth tables'],
        ],
    }

    # Do not apply until wikis and users have been created
    Mediawiki::Wiki <| |> -> Role::Centralauth::Migrate_user <| |>
    Mediawiki::User <| |> -> Role::Centralauth::Migrate_user <| |>
}

