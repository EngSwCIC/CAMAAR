class SyncLock
  def self.active?
    Rails.cache.read("sigaa_lock") == true
  end

  def self.start!
    Rails.cache.write("sigaa_lock", true)
  end

  def self.release!
    Rails.cache.delete("sigaa_lock")
  end
end