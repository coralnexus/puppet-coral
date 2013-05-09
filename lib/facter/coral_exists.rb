Facter.add(:coral_exists) do
  confine :kernel => :linux
  setcode do
    coral_exists = false
    
    begin
      Facter::Util::Resolution::exec('gem list coral_core -i 2> /dev/null')
      
      if $?.exitstatus == 0
        coral_exists = true
      end
      
    rescue Exception # Prevent abortions.
    end
    
    if coral_exists
      true
    else
      nil  
    end
  end
end