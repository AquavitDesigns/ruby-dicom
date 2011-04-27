# Loads the files that are used by Ruby DICOM.
#
# The following classes are meant to be used by users of Ruby DICOM:
# * DObject - for reading, manipulating and writing DICOM files.
# * DataElement, Sequence, Item, SuperParent, Elements - users who wish to interact with their DICOM objects will use these classes/modules.
# * SuperItem - Image related methods are found in this class.
# * DClient - for client side network communication, like querying, moving & sending DICOM files.
# * DServer - for server side network communication: Setting up your own DICOM storage node (SCP).
# * Anonymizer - a convenience class for anonymizing your DICOM files.
#
# The rest of the classes visible in the documentation generated by RDoc is in principle
# 'private' classes, which are mainly of interest to developers.

# Core library:
# Super classes/modules:
require 'dicom/image_processor'
require 'dicom/super_parent'
require 'dicom/super_item'
require 'dicom/elements'
# Subclasses and independent classes:
require 'dicom/data_element'
require 'dicom/d_client'
require 'dicom/dictionary'
require 'dicom/d_library'
require 'dicom/d_object'
require 'dicom/d_read'
require 'dicom/d_server'
require 'dicom/d_write'
require 'dicom/file_handler'
require 'dicom/item'
require 'dicom/link'
require 'dicom/sequence'
require 'dicom/stream'
# Extensions to the Ruby library:
require 'dicom/ruby_extensions'
# Module constants:
require 'dicom/version'
require 'dicom/constants'
# Image processors:
require 'dicom/image_processor_mini_magick'
require 'dicom/image_processor_r_magick'

# Extensions (non-core functionality):
require 'dicom/anonymizer'

require 'active_support/core_ext'
require 'dicom/dicom_extensions'
