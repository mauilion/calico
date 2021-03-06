def gen_values(versions, imageNames, imageRegistry)
    versionsYml = <<~EOF
    node:
      image: #{imageRegistry}#{imageNames["node"]}
      tag: #{versions["calico/node"]}
    calicoctl:
      image: #{imageRegistry}#{imageNames["calicoctl"]}
      tag: #{versions["calicoctl"]}
    typha:
      image: #{imageRegistry}#{imageNames["typha"]}
      tag: #{versions["typha"]}
    cni:
      image: #{imageRegistry}#{imageNames["cni"]}
      tag: #{versions["calico/cni"]}
    kubeControllers:
      image: #{imageRegistry}#{imageNames["kubeControllers"]}
      tag: #{versions["calico/kube-controllers"]}
    flannel:
      image: #{imageNames["flannel"]}
      tag: #{versions["flannel"]}
    dikastes:
      image: #{imageRegistry}#{imageNames["dikastes"]}
      tag: #{versions["calico/dikastes"]}
    flexvol:
      image: #{imageRegistry}#{imageNames["flexvol"]}
      tag: #{versions["flexvol"]}
    EOF
end


# Takes versions_yml which is structured as follows:
#
# {"v3.6"=>
#     ["components"=>
#        {"calico/node"=>{"version"=>"v3.6.0"},
#         "typha"=>{"version"=>"v3.6.0"}}]
#
# And for a given version, return a Hash of each components' version by component name e.g:
#
# {"calico/node"=>"v3.6.0",
#   "typha"=>"v3.6.0"}
#
def parse_versions(versions_yml, version)
  if not versions_yml.key?(version)
    raise IndexError.new "requested version '#{version}' not present in versions.yml"
  end

  components = versions_yml[version][0]["components"].clone
  return components.each { |key,val| components[key] = val["version"] }
end
