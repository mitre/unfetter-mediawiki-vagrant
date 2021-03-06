# == Class: role::wikigrok
# Creates an easy way to fill in missing Wikidata information
class role::wikigrok {
    include ::role::wikidata
    include ::role::mobilefrontend

    mediawiki::extension { 'WikiGrok':
        settings => [
            '$wgWikiGrokRepoMode = $wmgUseWikibaseRepo;',
        ],
    }
}
