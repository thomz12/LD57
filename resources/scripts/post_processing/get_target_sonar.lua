camera_name = "submarine_camera"

function start()
    entity.ui_image.image = find_entity(camera_name).scripts.sonar.sonar_target:get_texture_reference()
end