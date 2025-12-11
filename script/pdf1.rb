desc 'Cria um arquivo pdf à partir do html gerado'
require 'pdfkit'

task :pdf1 => :html do
  begin
    PDFKit.configure do |config|
      config.default_options = {
        enable_local_file_access: true,
      }
    end

    html = File.new("output/index.html").read
    kit = PDFKit.new(html, page_width: '235', page_height: '177.8')
    kit.stylesheets << 'layout/second.css'
    kit.stylesheets << 'layout/mac_classic.css'

    # Get an inline PDF
    pdf = kit.to_pdf

    # Save the PDF to a file
    file = kit.to_file('output/book.pdf')
    puts "PDF generated successfully: output/book.pdf"

    # Don't try to open the PDF in build environments
    # `open output/book.pdf`
  rescue => e
    puts "Warning: PDF generation failed: #{e.message}"
    puts "Build will continue without PDF. HTML version is still available."
  end
end
