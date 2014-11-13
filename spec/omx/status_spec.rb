require_relative '../spec_helper'

describe Omx::Status do

  before :all do
    @status = Omx::Status
  end

  mocked_patterns = [
      "12:43 /usr/bin/omxplayer.bin --adev hdmi \"A-FILE.mkv\" < /tmp/omxpipe",
      "12:43 /usr/bin/omxplayer.bin --adev hdmi A-FILE.mkv < /tmp/omxpipe",
      "12:43 /usr/bin/omxplayer.bin --adev hdmi \"A-FILE.mkv\"",
      "12:43 /usr/bin/omxplayer.bin --adev hdmi A-FILE.mkv",
      "12:43 /usr/bin/omxplayer.bin --adev hdmi --pos 0 A-FILE.mkv",
      "12:43 /usr/bin/omxplayer.bin --adev hdmi --pos 0 \"A-FILE.mkv\"",
      "       12:43 /usr/bin/omxplayer.bin --adev hdmi \"A-FILE.mkv\" < /tmp/omxpipe",
      "       12:43 /usr/bin/omxplayer.bin --adev hdmi A-FILE.mkv < /tmp/omxpipe",
      "       12:43 /usr/bin/omxplayer.bin --adev hdmi \"A-FILE.mkv\"",
      "       12:43 /usr/bin/omxplayer.bin --adev hdmi A-FILE.mkv",
      "       12:43 /usr/bin/omxplayer.bin --adev hdmi --pos 0 A-FILE.mkv",
      "       12:43 /usr/bin/omxplayer.bin --adev hdmi --pos 0 \"A-FILE.mkv\""
  ]

  mocked_patterns.to_enum.with_index(1).each { |pattern, idx|

    describe 'matching the params '.concat(idx.to_s) do

      before :each do
        @status.reload!.stubs(:status_command).returns pattern
      end

      it 'should gather the time' do
        @status.running_time.should == '12:43'
      end

      it 'should gather the filename' do
        @status.filename.should == 'A-FILE.mkv'
      end

      it 'should gather the audio mode' do
        @status.audio_out.should == 'hdmi'
      end

    end

  }

end
