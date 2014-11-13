module Omx
  class Status
    class << self

      def now_playing
        @r ||= begin
          results = status_pattern.match(status_command)
          # [time, audio_out, adev, filename]
          results ? results.captures : [nil, nil, nil, nil]
        end
      end

      def running_time
        now_playing[0]
      end

      def audio_out
        now_playing[1]
      end

      def filename
        result = now_playing[3].gsub /"/, ''
        return result
      end

      def playing?
        now_playing.compact.any?
      end

      def reload!
        remove_instance_variable :@r if @r
        self
      end

      def to_h
        playing? ? {
          'running_time' => running_time,
          'audio_out'    => audio_out,
          'filename'     => filename
        } : 'not playing'
      end

      private

        def status_pattern
            /^\s*([\d:.]+) \S*omxplayer\S* --adev (\S+)( --pos [\d+])?\s+("\S+"|\S+)( < \S+)?$/
        end

        def status_command
          # The [/] excludes self matches http://serverfault.com/q/367921
          `ps ax -o etime,args | grep [/]usr/bin/omxplayer.bin`
        end

    end
  end
end
