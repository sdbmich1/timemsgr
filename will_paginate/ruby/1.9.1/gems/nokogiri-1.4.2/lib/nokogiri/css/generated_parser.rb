#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.6
# from Racc grammer file "".
#

require 'racc/parser.rb'


module Nokogiri
  module CSS
    class GeneratedParser < Racc::Parser
##### State transition tables begin ###

racc_action_table = [
     3,    55,    26,    21,    12,    24,    56,     3,    81,     1,
    41,    12,    41,    56,     3,    23,     1,    80,    12,    18,
    92,    91,     4,     1,     9,    10,    18,    13,    16,     4,
    12,     9,    10,    18,    13,    16,     4,    12,     9,    10,
     3,    13,    16,    73,    12,    12,    60,    61,     4,     1,
    57,    10,    12,    44,    16,     4,    61,     1,    10,    18,
    41,    16,     4,     4,     9,    10,    10,    13,    16,    16,
     4,     3,    58,    10,     3,    13,    16,    57,    12,    12,
    27,    82,    28,    48,    26,    51,    12,    53,    26,    51,
    18,    53,    83,    18,     4,     9,     4,     4,     9,    10,
    10,    63,    16,    16,     4,    66,    68,    10,    26,    51,
    16,    53,    86,    87,    66,    68,    67,    69,    70,    62,
    72,    59,    90,    54,    64,    67,    69,    70,    93,    72,
    32,    34,    36,    64,    26,    51,   -22,    53,    95,    96,
    31,   nil,    33,    35 ]

racc_action_check = [
     0,    20,     3,     3,     0,     3,    43,    30,    52,     0,
    39,    30,    11,    20,    56,     3,    30,    43,    56,     0,
    71,    71,     0,    56,     0,     0,    30,     0,     0,    30,
     8,    30,    30,    56,    30,    30,    56,     6,    56,    56,
     9,    56,    56,    28,     9,     7,    24,    24,     8,     9,
    51,     8,    41,    10,     8,     6,    53,    41,     6,     9,
     7,     6,     9,     7,     9,     9,     7,     9,     9,     7,
    41,     4,    21,    41,    16,    41,    41,    21,    15,    17,
     4,    54,     4,    16,    63,    63,    77,    63,    61,    61,
     4,    61,    55,    16,    14,     4,    15,    17,    16,    15,
    17,    26,    15,    17,    77,    29,    29,    77,    57,    57,
    77,    57,    58,    60,    27,    27,    29,    29,    29,    25,
    29,    22,    65,    19,    29,    27,    27,    27,    74,    27,
     5,     5,     5,    27,    18,    18,     1,    18,    79,    87,
     5,   nil,     5,     5 ]

racc_action_pointer = [
    -2,   108,   nil,    -8,    69,   123,    31,    39,    24,    38,
    42,    -9,   nil,   nil,    70,    72,    72,    73,   124,    95,
     1,    65,    98,   nil,    35,    96,    89,   111,    18,   102,
     5,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   -11,
   nil,    46,   nil,    -6,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    38,   -15,    44,    70,    92,    12,    98,    99,   nil,
   106,    78,   nil,    74,   nil,    97,   nil,   nil,   nil,   nil,
   nil,    10,   nil,   nil,   103,   nil,   nil,    80,   nil,   115,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   126,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil ]

racc_action_default = [
   -23,   -20,    -2,   -68,   -68,   -17,   -52,   -44,   -49,   -23,
   -68,   -15,   -53,   -21,   -12,   -51,   -68,   -50,   -68,   -68,
   -68,   -37,   -68,   -27,   -35,   -68,   -36,   -56,   -68,   -56,
   -23,    -5,    -3,    -8,    -4,    -7,    -6,   -48,    -9,   -43,
   -11,   -23,   -45,   -68,   -18,   -14,   -13,   -47,   -42,   -41,
   -46,   -37,   -68,   -35,   -68,   -68,   -23,   -68,   -68,   -28,
   -40,   -68,   -29,   -68,   -57,   -68,   -62,   -58,   -63,   -59,
   -60,   -68,   -61,   -26,   -68,   -16,   -10,   -65,   -67,   -68,
   -31,   -30,   -19,    97,    -1,   -34,   -39,   -68,   -32,   -33,
   -24,   -54,   -55,   -25,   -66,   -64,   -38 ]

racc_goto_table = [
    37,    39,    42,    22,    40,    75,    20,    29,    45,    47,
    65,    50,    74,    38,    46,    43,    77,    30,    52,    49,
    25,    79,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    84,   nil,   nil,   nil,    78,    76,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    85,   nil,   nil,
   nil,    88,   nil,    89,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    94 ]

racc_goto_check = [
     7,     7,     7,    14,     8,     2,     1,     9,     8,     7,
    13,     7,    13,     6,    10,     1,     5,     3,    14,     9,
    15,    19,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     2,   nil,   nil,   nil,     7,     8,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,    14,   nil,   nil,
   nil,    14,   nil,    14,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     7 ]

racc_goto_pointer = [
   nil,     6,   -25,    12,   nil,   -25,     6,    -6,    -3,     3,
     0,   nil,   nil,   -17,     0,    17,   nil,   nil,   nil,   -20 ]

racc_goto_default = [
   nil,   nil,     2,   nil,     5,     7,   nil,    11,   nil,    14,
    15,    17,    19,   nil,   nil,   nil,     6,     8,    71,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  3, 32, :_reduce_1,
  1, 32, :_reduce_2,
  1, 34, :_reduce_3,
  1, 34, :_reduce_4,
  1, 34, :_reduce_5,
  1, 34, :_reduce_6,
  1, 34, :_reduce_7,
  1, 34, :_reduce_8,
  2, 35, :_reduce_9,
  3, 35, :_reduce_10,
  2, 35, :_reduce_11,
  1, 35, :_reduce_none,
  2, 35, :_reduce_13,
  2, 35, :_reduce_14,
  1, 35, :_reduce_15,
  3, 33, :_reduce_16,
  1, 33, :_reduce_none,
  2, 42, :_reduce_18,
  3, 36, :_reduce_19,
  1, 36, :_reduce_20,
  1, 36, :_reduce_21,
  1, 43, :_reduce_22,
  0, 43, :_reduce_none,
  4, 41, :_reduce_24,
  4, 41, :_reduce_25,
  3, 41, :_reduce_26,
  2, 40, :_reduce_27,
  3, 40, :_reduce_28,
  3, 40, :_reduce_29,
  3, 40, :_reduce_30,
  3, 40, :_reduce_31,
  3, 45, :_reduce_32,
  3, 45, :_reduce_33,
  3, 45, :_reduce_34,
  1, 45, :_reduce_none,
  1, 45, :_reduce_none,
  1, 45, :_reduce_37,
  4, 46, :_reduce_38,
  3, 46, :_reduce_39,
  2, 46, :_reduce_40,
  2, 47, :_reduce_41,
  2, 47, :_reduce_42,
  1, 37, :_reduce_none,
  0, 37, :_reduce_none,
  2, 38, :_reduce_45,
  2, 38, :_reduce_46,
  2, 38, :_reduce_47,
  2, 38, :_reduce_48,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 48, :_reduce_53,
  2, 44, :_reduce_54,
  2, 44, :_reduce_55,
  0, 44, :_reduce_none,
  1, 49, :_reduce_57,
  1, 49, :_reduce_58,
  1, 49, :_reduce_59,
  1, 49, :_reduce_60,
  1, 49, :_reduce_61,
  1, 49, :_reduce_62,
  1, 49, :_reduce_63,
  3, 39, :_reduce_64,
  1, 50, :_reduce_none,
  2, 50, :_reduce_none,
  1, 50, :_reduce_none ]

racc_reduce_n = 68

racc_shift_n = 97

racc_token_table = {
  false => 0,
  :error => 1,
  :FUNCTION => 2,
  :INCLUDES => 3,
  :DASHMATCH => 4,
  :LBRACE => 5,
  :HASH => 6,
  :PLUS => 7,
  :GREATER => 8,
  :S => 9,
  :STRING => 10,
  :IDENT => 11,
  :COMMA => 12,
  :NUMBER => 13,
  :PREFIXMATCH => 14,
  :SUFFIXMATCH => 15,
  :SUBSTRINGMATCH => 16,
  :TILDE => 17,
  :NOT_EQUAL => 18,
  :SLASH => 19,
  :DOUBLESLASH => 20,
  :NOT => 21,
  :EQUAL => 22,
  :RPAREN => 23,
  :LSQUARE => 24,
  :RSQUARE => 25,
  :HAS => 26,
  "." => 27,
  "|" => 28,
  "*" => 29,
  ":" => 30 }

racc_nt_base = 31

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "FUNCTION",
  "INCLUDES",
  "DASHMATCH",
  "LBRACE",
  "HASH",
  "PLUS",
  "GREATER",
  "S",
  "STRING",
  "IDENT",
  "COMMA",
  "NUMBER",
  "PREFIXMATCH",
  "SUFFIXMATCH",
  "SUBSTRINGMATCH",
  "TILDE",
  "NOT_EQUAL",
  "SLASH",
  "DOUBLESLASH",
  "NOT",
  "EQUAL",
  "RPAREN",
  "LSQUARE",
  "RSQUARE",
  "HAS",
  "\".\"",
  "\"|\"",
  "\"*\"",
  "\":\"",
  "$start",
  "selector",
  "simple_selector_1toN",
  "combinator",
  "simple_selector",
  "element_name",
  "hcap_0toN",
  "hcap_1toN",
  "negation",
  "function",
  "attrib",
  "class",
  "namespace",
  "attrib_val_0or1",
  "expr",
  "an_plus_b",
  "pseudo",
  "attribute_id",
  "eql_incl_dash",
  "negation_arg" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

def _reduce_1(val, _values, result)
        result = [val.first, val.last].flatten
      
    result
end

def _reduce_2(val, _values, result)
 result = val.flatten 
    result
end

def _reduce_3(val, _values, result)
 result = :DIRECT_ADJACENT_SELECTOR 
    result
end

def _reduce_4(val, _values, result)
 result = :CHILD_SELECTOR 
    result
end

def _reduce_5(val, _values, result)
 result = :PRECEDING_SELECTOR 
    result
end

def _reduce_6(val, _values, result)
 result = :DESCENDANT_SELECTOR 
    result
end

def _reduce_7(val, _values, result)
 result = :DESCENDANT_SELECTOR 
    result
end

def _reduce_8(val, _values, result)
 result = :CHILD_SELECTOR 
    result
end

def _reduce_9(val, _values, result)
        result =  if val[1].nil?
                    val.first
                  else
                    Node.new(:CONDITIONAL_SELECTOR, [val.first, val[1]])
                  end
      
    result
end

def _reduce_10(val, _values, result)
        result = Node.new(:CONDITIONAL_SELECTOR,
          [
            val.first,
            Node.new(:COMBINATOR, [val[1], val.last])
          ]
        )
      
    result
end

def _reduce_11(val, _values, result)
        result = Node.new(:CONDITIONAL_SELECTOR, val)
      
    result
end

# reduce 12 omitted

def _reduce_13(val, _values, result)
        result = Node.new(:CONDITIONAL_SELECTOR, val)
      
    result
end

def _reduce_14(val, _values, result)
        result = Node.new(:CONDITIONAL_SELECTOR,
          [
            Node.new(:ELEMENT_NAME, ['*']),
            Node.new(:COMBINATOR, val)
          ]
        )
      
    result
end

def _reduce_15(val, _values, result)
        result = Node.new(:CONDITIONAL_SELECTOR,
          [Node.new(:ELEMENT_NAME, ['*']), val.first]
        )
      
    result
end

def _reduce_16(val, _values, result)
        result = Node.new(val[1], [val.first, val.last])
      
    result
end

# reduce 17 omitted

def _reduce_18(val, _values, result)
 result = Node.new(:CLASS_CONDITION, [val[1]]) 
    result
end

def _reduce_19(val, _values, result)
        result = Node.new(:ELEMENT_NAME,
          [[val.first, val.last].compact.join(':')]
        )
      
    result
end

def _reduce_20(val, _values, result)
        name = @namespaces.key?('xmlns') ? "xmlns:#{val.first}" : val.first
        result = Node.new(:ELEMENT_NAME, [name])
      
    result
end

def _reduce_21(val, _values, result)
 result = Node.new(:ELEMENT_NAME, val) 
    result
end

def _reduce_22(val, _values, result)
 result = val[0] 
    result
end

# reduce 23 omitted

def _reduce_24(val, _values, result)
        result = Node.new(:ATTRIBUTE_CONDITION,
          [Node.new(:ELEMENT_NAME, [val[1]])] + (val[2] || [])
        )
      
    result
end

def _reduce_25(val, _values, result)
        result = Node.new(:ATTRIBUTE_CONDITION,
          [val[1]] + (val[2] || [])
        )
      
    result
end

def _reduce_26(val, _values, result)
        # Non standard, but hpricot supports it.
        result = Node.new(:PSEUDO_CLASS,
          [Node.new(:FUNCTION, ['nth-child(', val[1]])]
        )
      
    result
end

def _reduce_27(val, _values, result)
        result = Node.new(:FUNCTION, [val.first.strip])
      
    result
end

def _reduce_28(val, _values, result)
        result = Node.new(:FUNCTION, [val.first.strip, val[1]].flatten)
      
    result
end

def _reduce_29(val, _values, result)
        result = Node.new(:FUNCTION, [val.first.strip, val[1]].flatten)
      
    result
end

def _reduce_30(val, _values, result)
        result = Node.new(:FUNCTION, [val.first.strip, val[1]].flatten)
      
    result
end

def _reduce_31(val, _values, result)
        result = Node.new(:FUNCTION, [val.first.strip, val[1]].flatten)
      
    result
end

def _reduce_32(val, _values, result)
 result = [val.first, val.last] 
    result
end

def _reduce_33(val, _values, result)
 result = [val.first, val.last] 
    result
end

def _reduce_34(val, _values, result)
 result = [val.first, val.last] 
    result
end

# reduce 35 omitted

# reduce 36 omitted

def _reduce_37(val, _values, result)
        if val[0] == 'even'
          val = ["2","n","+","0"]
          result = Node.new(:AN_PLUS_B, val)
        elsif val[0] == 'odd'
          val = ["2","n","+","1"]
          result = Node.new(:AN_PLUS_B, val)
        else
          # This is not CSS standard.  It allows us to support this:
          # assert_xpath("//a[foo(., @href)]", @parser.parse('a:foo(@href)'))
          # assert_xpath("//a[foo(., @a, b)]", @parser.parse('a:foo(@a, b)'))
          # assert_xpath("//a[foo(., a, 10)]", @parser.parse('a:foo(a, 10)'))
          result = val
        end
      
    result
end

def _reduce_38(val, _values, result)
        if val[1] == 'n'
          result = Node.new(:AN_PLUS_B, val)
        else
          raise Racc::ParseError, "parse error on IDENT '#{val[1]}'"
        end
      
    result
end

def _reduce_39(val, _values, result)
               # n+3, -n+3
        if val[0] == 'n'
          val.unshift("1")
          result = Node.new(:AN_PLUS_B, val)
        elsif val[0] == '-n'
          val[0] = 'n'
          val.unshift("-1")
          result = Node.new(:AN_PLUS_B, val)
        else
          raise Racc::ParseError, "parse error on IDENT '#{val[1]}'"
        end
      
    result
end

def _reduce_40(val, _values, result)
        if val[1] == 'n'
          val << "+"
          val << "0"
          result = Node.new(:AN_PLUS_B, val)
        else
          raise Racc::ParseError, "parse error on IDENT '#{val[1]}'"
        end
      
    result
end

def _reduce_41(val, _values, result)
        result = Node.new(:PSEUDO_CLASS, [val[1]])
      
    result
end

def _reduce_42(val, _values, result)
 result = Node.new(:PSEUDO_CLASS, [val[1]]) 
    result
end

# reduce 43 omitted

# reduce 44 omitted

def _reduce_45(val, _values, result)
        result = Node.new(:COMBINATOR, val)
      
    result
end

def _reduce_46(val, _values, result)
        result = Node.new(:COMBINATOR, val)
      
    result
end

def _reduce_47(val, _values, result)
        result = Node.new(:COMBINATOR, val)
      
    result
end

def _reduce_48(val, _values, result)
        result = Node.new(:COMBINATOR, val)
      
    result
end

# reduce 49 omitted

# reduce 50 omitted

# reduce 51 omitted

# reduce 52 omitted

def _reduce_53(val, _values, result)
 result = Node.new(:ID, val) 
    result
end

def _reduce_54(val, _values, result)
 result = [val.first, val[1]] 
    result
end

def _reduce_55(val, _values, result)
 result = [val.first, val[1]] 
    result
end

# reduce 56 omitted

def _reduce_57(val, _values, result)
 result = :equal 
    result
end

def _reduce_58(val, _values, result)
 result = :prefix_match 
    result
end

def _reduce_59(val, _values, result)
 result = :suffix_match 
    result
end

def _reduce_60(val, _values, result)
 result = :substring_match 
    result
end

def _reduce_61(val, _values, result)
 result = :not_equal 
    result
end

def _reduce_62(val, _values, result)
 result = :includes 
    result
end

def _reduce_63(val, _values, result)
 result = :dash_match 
    result
end

def _reduce_64(val, _values, result)
        result = Node.new(:NOT, [val[1]])
      
    result
end

# reduce 65 omitted

# reduce 66 omitted

# reduce 67 omitted

def _reduce_none(val, _values, result)
  val[0]
end

    end   # class GeneratedParser
    end   # module CSS
  end   # module Nokogiri
