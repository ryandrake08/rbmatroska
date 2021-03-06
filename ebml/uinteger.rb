#!/usr/bin/ruby

#
# Distributed under the MIT license
# see the file COPYING for details
# or visit http://www.opensource.org/licenses/mit-license.php
#
# $Id: uinteger.rb 787 2004-09-12 15:28:30Z mosu $
#
# A simple EBML parser based loosely on libebml and other
# EBML implementations. It also contains classes for the global EBML
# elements mentioned on # http://www.matroska.org/technical/specs/index.html
#
# Written by Moritz Bunkus <moritz@bunkus.org>.
#

module Ebml
  class UInteger < Element
    attr_accessor :value

    def read(ef)
      @value = 0
      1.upto(@data_size) do
        if RUBY_VERSION >= '1.8.7'
          byte = ef.io.readbyte
        else
          byte = ef.io.readchar
        end
        @value = (@value << 8) | byte
      end

      return self
    end

    def write_data(ef)
      a = Array.new
      shift = ((@data_size - 1) * 8)
      mask = 0xff << shift
      @data_size.downto(1) do
        a.push((@value & mask) >> shift)
        shift -= 8
        mask >>= 8
      end
      ef.io.write(a.pack("C*"))
    end

    def update_size
      @value ||= 0

      if (@value <= 0xff)
        @data_size = 1
      elsif (@value <= 0xffff)
        @data_size = 2
      elsif (@value <= 0xffffff)
        @data_size = 3
      elsif (@value <= 0xffffffff)
        @data_size = 4
      elsif (@value <= 0xffffffffff)
        @data_size = 5
      elsif (@value <= 0xffffffffffff)
        @data_size = 6
      elsif (@value <= 0xffffffffffffff)
        @data_size = 7
      else
        @data_size = 8
      end

      return super
    end

    def to_i
      @value ||= 0
      return @value
    end

    def to_s
      return to_i.to_s
    end

  end                           # class UInteger

end                             # module Ebml
