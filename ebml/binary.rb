#!/usr/bin/ruby

#
# Distributed under the MIT license
# see the file COPYING for details
# or visit http://www.opensource.org/licenses/mit-license.php
#
# $Id: binary.rb 787 2004-09-12 15:28:30Z mosu $
#
# A simple EBML parser based loosely on libebml and other
# EBML implementations. It also contains classes for the global EBML
# elements mentioned on # http://www.matroska.org/technical/specs/index.html
#
# Written by Moritz Bunkus <moritz@bunkus.org>.
#

module Ebml
  class Binary < Element
    attr_accessor :value

    def read(ef)
      @value = ef.io.read(@data_size).unpack("C*")
      raise EOFError if (@value.size < @data_size)

      return self
    end

    def write_data(ef)
      ef.io.write(@value.pack("C*"))
    end

    def update_size
      @data_size = @value.size
      return super
    end

    def to_s
      @value ||= Array.new
      return "[Binary size " + @data_size.to_s + "]"
    end

  end                           # class Binary

end                             # module Ebml
