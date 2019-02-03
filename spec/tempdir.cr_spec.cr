require "./spec_helper"

describe Tempdir do
  it "creates an empty directory" do
    m = Tempdir.new
    begin
      n = 0
      while (path = m.read)
        n += 1 if path != "." && path != ".."
      end
      n.should eq 0
    ensure
      m.close
    end
  end

  it "removes the created directory after close" do
    m = Tempdir.new
    begin
      path = m.path
      File.open(File.join(path, "temp"), "w") do |fp|
        fp.puts "temp"
      end
    ensure
      m.close
    end
    File.exists?(path).should be_false
  end

  it "raises if other writable and not sticky directory is used for base" do
    m = Tempdir.new
    begin
      dir = File.join(m.path, "foo")
      Dir.mkdir(dir)
      File.chmod(dir, 0o777)
      expect_raises(ArgumentError) do
        m = Tempdir.new(dir: dir)
      end
    ensure
      m.close
    end
  end

  it "creates 'go-rwx' directory" do
    m = Tempdir.new
    begin
      info = File.info(m.path)
      perm = info.permissions
      perm.group_read?.should be_false
      perm.group_write?.should be_false
      perm.group_execute?.should be_false
      perm.other_read?.should be_false
      perm.other_write?.should be_false
      perm.other_execute?.should be_false
    ensure
      m.close
    end
  end
end


describe "Dir.mktmpdir" do
  it "removed after block left" do
    path = ""
    Dir.mktmpdir do |dir|
      path = dir
      File.open(File.join(dir, "temp"), "w") do |fp|
        fp.puts("temp")
      end
    end
    path.empty?.should be_false
    File.exists?(path).should be_false
  end

  it "removed after block left (with exception)" do
    path = ""
    begin
      Dir.mktmpdir do |dir|
        path = dir
        raise Exception.new
      end
    rescue
    end
    path.empty?.should be_false
    File.exists?(path).should be_false
  end
end
