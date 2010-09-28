require 'digest/md5'

class Dot < Liquid::Block
  def initialize(tag_name, markup, tokens)
    @dot_opts = markup
    super
  end

  def render(context)
    code =  super.join
    global_dot_opts = context.registers[:site].config['dot']['opts']
    types = ['png']
    out_dir = context.registers[:site].config['dot']['out_dir']
    out_url = context.registers[:site].config['dot']['out_url']
    md5 = Digest::MD5.hexdigest(code + global_dot_opts + @dot_opts)
    out_file = File.join(out_dir, md5 + '.' + types[0])
    unless File.exists?(out_file)
      dot_file = File.join(out_dir, md5 + '.dot')
      File.open(dot_file, 'w') do |f|
        f.write(code)
      end
      c = []
      types.each do |type|
        out_file = File.join(out_dir, md5 + '.' + type)
        c << "-T#{type} -o#{out_file}"
      end

      cmd = "dot #{global_dot_opts} #{@dot_opts} #{c.join ' '} #{dot_file}"
      $stderr.puts cmd
      system cmd
    end
    # assumes png.
    width, height = IO.read(out_file)[0x10..0x18].unpack('NN')
    "\n<center><div class=\"dot_bitmap\">\n<img src=\"#{out_url + '/' + md5 + '.png'}\" alt=\"Dot graph\" width=\"#{width}\" height=\"#{height}\" />\n</div></center>\n"
  end
end

Liquid::Template.register_tag('dot', Dot)
