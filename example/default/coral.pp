/**
 * Coral module default configurations
 * -----------------------------------------------------------------------------
 *
 * These module specific configurations are used as a last resort in puppet
 * nodes and classes in the manifest directory.
 *
 * This file exists in a directory beneath the primary default.pp file.  The
 * exact directory is controlled by the default file (parent), but I normally
 * use the "default" directory, because that is what it is, a collection of
 * defaults.
 *
 * Each module that has project level default configurations should have a
 * class similar to the one below.  It should inherit from coral::default or
 * any other default file and be of the form coral::default::{module_name}.
 *
 * These defaults are used unless Hiera finds the property in question.  This
 * system provides an easy way to provide project level defaults without the
 * overhead of a Hiera Puppet backend, which does not work well with directory
 * based Hiera hierarchies useful in backend processors like hiera-json.
 */
class coral::default::coral inherits coral::default {
  $facts = {
    'server_identity' => 'test',
    'server_stage'    => 'bootstrap',
    'server_type'     => 'core'
  }
}
