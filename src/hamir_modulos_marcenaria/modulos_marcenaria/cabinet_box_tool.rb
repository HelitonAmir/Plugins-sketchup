module HamirTools
  module ModulosMarcenaria
    class CabinetBoxTool
      def activate
        @ip = Sketchup::InputPoint.new
        @first_point = nil
      end

      def onMouseMove(flags, x, y, view)
        @ip.pick(view, x, y)
        view.invalidate if @ip.display?
      end

      def onButtonDown(flags, x, y, view)
        if @first_point.nil?
          @ip.pick(view, x, y)
          @first_point = @ip.position
          view.tooltip = "Clique novamente para definir o tamanho do caixote."
        else
          @ip.pick(view, x, y)
          @second_point = @ip.position
          create_cabinet_box(@first_point, @second_point, Sketchup.active_model)
          @first_point = nil
          view.tooltip = "Caixote criado."
          Sketchup.active_model.select_tool(nil) # volta para a ferramenta padrão
        end
      end

      def draw(view)
       return unless @first_point && @ip.valid?

       view.set_color_from_line(@first_point, @ip.position)
       view.draw_line(@first_point, @ip.position)
      end

      def create_cabinet_box(p1, p2, model)
        entities = model.active_entities
        group = entities.add_group
        cabinet_box = group.entities;

        x1, y1 = p1.x, p1.y
        x2, y2 = p2.x, p2.y
        z = p1.z

        height = 720.mm

        pt1 = Geom::Point3d.new(x1, y1, z)
        pt2 = Geom::Point3d.new(x2, y1, z)
        pt3 = Geom::Point3d.new(x2, y2, z)
        pt4 = Geom::Point3d.new(x1, y2, z)

        base = [pt1, pt2, pt3, pt4]
        face = model.active_entities.add_face(base)
        face.pushpull(height)
      end
  end # module ModulosMarcenaria
end # module HamirTools
