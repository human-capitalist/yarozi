require 'minitest/autorun'
require 'minitest/stub_any_instance'
require 'bundler'
Bundler.require

loader = Zeitwerk::Loader.new
loader.push_dir('./lib')
loader.setup # ready!

Logging.setup

Minitest.parallel_executor = Minitest::ForkExecutor.new

class Test < Minitest::Test

# Disk mocking

  RESCUE_DISKS = 'test/data/rescue-disks.txt'
  HPE_DISKS = 'test/data/hpe-disks.txt'
  USB_DISKS = 'test/data/usb-disks.txt'

  def rescue_disks(&block)
    with_disks RESCUE_DISKS, &block
  end

  def hpe_disks(&block)
    with_disks HPE_DISKS, &block
  end


  def usb_disks(&block)
    with_disks USB_DISKS, &block
  end


  def with_disks(disks_file)
    Disk.stub_any_instance(:rotation, Proc.new{ /^ata-ST/ =~ id } ) do
      Disk.stub :get_hwinfo, IO.read(disks_file) do
        Disk.reload
        yield
      end
    end
  end

# Screen mocking

  def with_msgbox
    MRDialog.stub_any_instance(:msgbox, Proc.new{|*args| args} ) do
      yield
    end
  end

  def with_screen(rows, cols)
    Question::Dialog.stub :rows, rows do
      Question::Dialog.stub :cols, cols do
        yield
      end
    end
  end

end



