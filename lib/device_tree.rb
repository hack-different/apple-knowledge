# frozen_string_literal: true

#
# typedef struct
# {
#     uint32_t nprop;
#     uint32_t nchld;
#     char prop[];
# } dt_node_t;
#
# typedef struct
# {
#     char key[DT_KEY_LEN];
#     uint32_t len;
#     char val[];
# } dt_prop_t;
#
DT_KEY_LEN = 32

class DtNode
  attr_reader :name, :compatible, :handle, :functions, :props, :children
end
