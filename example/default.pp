/**
 * Coral default configurations
 * -----------------------------------------------------------------------------
 *
 * These configurations are used as a last resort in puppet nodes and classes
 * in the manifest directory.
 *
 * This file exists in the same directory as the bootstrap and base profiles.
 * I refer to this combination of defaults and basic profiles as
 * a "manifest core".
 *
 * This manifest core is included as a git submodule in a container
 * project and gives the maintainer/developer a stripped down base platform
 * with a completely custimizable framework that is extended in various
 * top level project directories, such as a profiles directory or a project
 * level modules directory.
 */
class coral::default {

}

# This assumes we have created a default directory which contains all of our
# default configurations.
import "default/*.pp"
include coral::default::coral # This module's default configurations

# Each module that has project level default configurations should be
# included below:

# include coral::default::{module_name}

# The above should have a corresponding {module_name}.pp in the default
# directory.  See the included default/coral.pp for details.
