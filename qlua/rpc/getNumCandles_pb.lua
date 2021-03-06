-- Generated by protobuf; do not edit
local module = {}
local protobuf = require 'protobuf'


module.REQUEST = protobuf.Descriptor()
module.REQUEST_TAG_FIELD = protobuf.FieldDescriptor()
module.RESULT = protobuf.Descriptor()
module.RESULT_NUM_CANDLES_FIELD = protobuf.FieldDescriptor()

module.REQUEST_TAG_FIELD.name = 'tag'
module.REQUEST_TAG_FIELD.full_name = '.qlua.rpc.getNumCandles.Request.tag'
module.REQUEST_TAG_FIELD.number = 1
module.REQUEST_TAG_FIELD.index = 0
module.REQUEST_TAG_FIELD.label = 1
module.REQUEST_TAG_FIELD.has_default_value = false
module.REQUEST_TAG_FIELD.default_value = ''
module.REQUEST_TAG_FIELD.type = 9
module.REQUEST_TAG_FIELD.cpp_type = 9

module.REQUEST.name = 'Request'
module.REQUEST.full_name = '.qlua.rpc.getNumCandles.Request'
module.REQUEST.nested_types = {}
module.REQUEST.enum_types = {}
module.REQUEST.fields = {module.REQUEST_TAG_FIELD}
module.REQUEST.is_extendable = false
module.REQUEST.extensions = {}
module.RESULT_NUM_CANDLES_FIELD.name = 'num_candles'
module.RESULT_NUM_CANDLES_FIELD.full_name = '.qlua.rpc.getNumCandles.Result.num_candles'
module.RESULT_NUM_CANDLES_FIELD.number = 1
module.RESULT_NUM_CANDLES_FIELD.index = 0
module.RESULT_NUM_CANDLES_FIELD.label = 1
module.RESULT_NUM_CANDLES_FIELD.has_default_value = false
module.RESULT_NUM_CANDLES_FIELD.default_value = 0
module.RESULT_NUM_CANDLES_FIELD.type = 5
module.RESULT_NUM_CANDLES_FIELD.cpp_type = 1

module.RESULT.name = 'Result'
module.RESULT.full_name = '.qlua.rpc.getNumCandles.Result'
module.RESULT.nested_types = {}
module.RESULT.enum_types = {}
module.RESULT.fields = {module.RESULT_NUM_CANDLES_FIELD}
module.RESULT.is_extendable = false
module.RESULT.extensions = {}

module.Request = protobuf.Message(module.REQUEST)
module.Result = protobuf.Message(module.RESULT)


module.MESSAGE_TYPES = {'Request','Result'}
module.ENUM_TYPES = {}

return module
