-- Generated by protobuf; do not edit
local module = {}
local protobuf = require 'protobuf'


module.REQUEST = protobuf.Descriptor()
module.REQUEST_CLASS_CODE_FIELD = protobuf.FieldDescriptor()
module.RESULT = protobuf.Descriptor()
module.RESULT_CLASS_SECURITIES_FIELD = protobuf.FieldDescriptor()

module.REQUEST_CLASS_CODE_FIELD.name = 'class_code'
module.REQUEST_CLASS_CODE_FIELD.full_name = '.qlua.rpc.getClassSecurities.Request.class_code'
module.REQUEST_CLASS_CODE_FIELD.number = 1
module.REQUEST_CLASS_CODE_FIELD.index = 0
module.REQUEST_CLASS_CODE_FIELD.label = 1
module.REQUEST_CLASS_CODE_FIELD.has_default_value = false
module.REQUEST_CLASS_CODE_FIELD.default_value = ''
module.REQUEST_CLASS_CODE_FIELD.type = 9
module.REQUEST_CLASS_CODE_FIELD.cpp_type = 9

module.REQUEST.name = 'Request'
module.REQUEST.full_name = '.qlua.rpc.getClassSecurities.Request'
module.REQUEST.nested_types = {}
module.REQUEST.enum_types = {}
module.REQUEST.fields = {module.REQUEST_CLASS_CODE_FIELD}
module.REQUEST.is_extendable = false
module.REQUEST.extensions = {}
module.RESULT_CLASS_SECURITIES_FIELD.name = 'class_securities'
module.RESULT_CLASS_SECURITIES_FIELD.full_name = '.qlua.rpc.getClassSecurities.Result.class_securities'
module.RESULT_CLASS_SECURITIES_FIELD.number = 1
module.RESULT_CLASS_SECURITIES_FIELD.index = 0
module.RESULT_CLASS_SECURITIES_FIELD.label = 1
module.RESULT_CLASS_SECURITIES_FIELD.has_default_value = false
module.RESULT_CLASS_SECURITIES_FIELD.default_value = ''
module.RESULT_CLASS_SECURITIES_FIELD.type = 9
module.RESULT_CLASS_SECURITIES_FIELD.cpp_type = 9

module.RESULT.name = 'Result'
module.RESULT.full_name = '.qlua.rpc.getClassSecurities.Result'
module.RESULT.nested_types = {}
module.RESULT.enum_types = {}
module.RESULT.fields = {module.RESULT_CLASS_SECURITIES_FIELD}
module.RESULT.is_extendable = false
module.RESULT.extensions = {}

module.Request = protobuf.Message(module.REQUEST)
module.Result = protobuf.Message(module.RESULT)


module.MESSAGE_TYPES = {'Request','Result'}
module.ENUM_TYPES = {}

return module
