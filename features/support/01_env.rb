require_relative '../support/api_call_helper'

def same_content?(array1, array2)
  array1 - array2 == array2 - array1 &&
      array1.length == array2.length
end