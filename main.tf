resource "oci_containerengine_cluster" "cluster" {
  compartment_id = var.compartment_id
  kubernetes_version = var.cluster_kubernetes_version
  name = var.cluster_name
  vcn_id = var.vcn_id

    endpoint_config {
        is_public_ip_enabled = var.cluster_endpoint_config.is_public_ip_enabled
        nsg_ids = var.cluster_endpoint_config.nsg_ids
        subnet_id = var.cluster_endpoint_config.subnet_id
    }



  options {
    
    add_ons {
        is_kubernetes_dashboard_enabled = var.cluster_options.add_ons.is_kubernetes_dashboard_enabled
        is_tiller_enabled = var.cluster_options.add_ons.is_tiller_enabled
    }
    
    kubernetes_network_config {
        pods_cidr = var.cluster_options.kubernetes_network_config.pods_cidr
        services_cidr = var.cluster_options.kubernetes_network_config.services_cidr
    }

    service_lb_subnet_ids = var.cluster_options.service_lb_subnet_ids
  }
}

resource "oci_containerengine_node_pool" "node_pool" {
    
    for_each = var.node_pool

    cluster_id = oci_containerengine_cluster.cluster.id
    compartment_id = var.compartment_id
    
    kubernetes_version = each.value.kubernetes_version
    name = each.value.name
    node_shape = each.value.node_shape
 
    node_config_details {
        placement_configs {
            availability_domain = each.value.node_config_details.placement_configs.availability_domain
            subnet_id = each.value.node_config_details.placement_configs.subnet_id
        }
        size = each.value.node_config_details.size
        nsg_ids = each.value.node_config_details.nsg_ids
    }

    node_source_details {
        image_id = each.value.node_source_details.image_id
        source_type = each.value.node_source_details.source_type

    }
    node_shape_config {
        memory_in_gbs = each.value.node_shape_config.memory_in_gbs
        ocpus = each.value.node_shape_config.ocpus
    }

}