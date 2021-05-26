require 'test'

class TestCompression < Test

  def test_ask
    mixed_disks do
      result = nil
      task = Task.new
      with_screen 46, 200 do
        with_dialog :menu, Proc.new{|*args| result = args; "gzip"} do
          q = RootInstaller::Questions::Compression.new(task)
          q.ask
          assert_instance_of Dialog, q.wizard
          assert_equal "Root Dataset Compression", q.wizard.title
          assert_equal "YAROZI - Yet Another Root On ZFS installer", q.wizard.backtitle
          assert_equal fetch_or_save(result.to_s), result.to_s
          assert_equal "gzip", q.instance_variable_get(:@choice)
        end
      end  
    end  
  end

  def test_respond_off
    q = RootInstaller::Questions::Compression.new(Task.new)
    q.instance_variable_set :@choice, "off"
    q.respond
    assert_equal "off", q.task.root_compression_type
    assert_equal 0, q.subquestions.length
  end

  def test_respond_gzip
    q = RootInstaller::Questions::Compression.new(Task.new)
    q.instance_variable_set :@choice, "gzip"
    q.respond
    assert_equal "gzip", q.task.root_compression_type
    assert_equal 1, q.subquestions.length
    assert_instance_of RootInstaller::Questions::Compression::GzipLevel, q.subquestions.first
  end

  def test_respond_zstd
    q = RootInstaller::Questions::Compression.new(Task.new)
    q.instance_variable_set :@choice, "zstd"
    q.respond
    assert_equal "zstd", q.task.root_compression_type
    assert_equal 1, q.subquestions.length
    assert_instance_of RootInstaller::Questions::Compression::ZstdLevel, q.subquestions.first
  end

  def test_respond_zstd_fast
    q = RootInstaller::Questions::Compression.new(Task.new)
    q.instance_variable_set :@choice, "zstd-fast"
    q.respond
    assert_equal "zstd-fast", q.task.root_compression_type
    assert_equal 1, q.subquestions.length
    assert_instance_of RootInstaller::Questions::Compression::ZstdFastLevel, q.subquestions.first
  end

end
  