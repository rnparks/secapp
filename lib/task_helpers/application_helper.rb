class ApplicationHelper

  def self.chunker f_in, chunksize = 10_000_000
	  outfilenum = 1
	  File.open(f_in,"r") do |fh_in|
	    until fh_in.eof?
	      File.open("#{f_in}_#{outfilenum}.txt","w") do |fh_out|
	        line = ""
	        while fh_out.size <= (chunksize-line.length) && !fh_in.eof?
	          line = fh_in.readline
	          fh_out << line
	        end
	      end
	      outfilenum += 1
	    end
	  end
	end
end
