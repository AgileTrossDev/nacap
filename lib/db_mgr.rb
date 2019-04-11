class DbMgr
  def initialize
    # TODO: Pull from environment
    
  end
  
  
  # Inserts a complete set of User data into the datbase
  def insert_if_does_not_exist user_data
  
    # User Check and Insert
    begin
      con = PG.connect :dbname => 'nacap_demo', :user => 'alberta'
      con.prepare 'stm1', "SELECT EXISTS(select 1 from users where username=$1)"
      rs = con.exec_prepared 'stm1', [user_data["name"]]
          
      puts "RS: #{rs.values == [["f"]]} #{rs.values}" 
    
      if rs.values == [["f"]] then
        con.prepare 'stm_insert', "INSERT INTO users(username) VALUES($1);"
        rs = con.exec_prepared 'stm_insert', [user_data["name"]]
          
        puts "RS: #{rs.values == [["f"]]} #{rs.values}" 
                       
      end
    
    
      con.prepare 'stm2', "SELECT * from users"
      rs = con.exec_prepared 'stm2'
      puts "RS: #{rs.values}" 
    
    rescue PG::Error => e
        puts e.message 
    ensure
        rs.clear if rs
        con.close if con
    end
  end
  
end
