require "rdoc/task"

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "app/**/*.rb", "lib/**/*.rb")
  rdoc.rdoc_dir = "doc"
  rdoc.title = "CAMAAR - Sistema para Avaliação de Atividades Acadêmicas Remotas do CIC"
  rdoc.options << "--line-numbers" << "--inline-source"
end
