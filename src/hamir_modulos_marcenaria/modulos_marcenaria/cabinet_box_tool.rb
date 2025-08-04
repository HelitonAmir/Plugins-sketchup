require 'sketchup.rb'
module HamirTools
  module ModulosMarcenaria
    class CabinetBoxTool
      def initialize
        @cursor_id = nil
        # Load vector cursor format depending on platform.
        ext = Sketchup.platform == :platform_win ? 'svg' : 'pdf'
        cursor_path = File.join(__dir__, "mouse_cursors", "cabinet_box.#{ext}")
        @cursor_id = UI.create_cursor(cursor_path, 2, 38)
      end

      def activate
        @mouse_ip = Sketchup::InputPoint.new
        @picked_first_ip = Sketchup::InputPoint.new
        update_ui
      end

      def deactivate(view)
        view.invalidate
      end

      def resume(view)
        update_ui
        view.invalidate
      end

      def suspend(view)
        view.invalidate
      end

      def onCancel(reason, view)
        reset_tool
        view.invalidate
      end

      def onMouseMove(flags, x, y, view)
        if picked_first_point?
          @mouse_ip.pick(view, x, y, @picked_first_ip)
        else
          @mouse_ip.pick(view, x, y)
        end
        view.tooltip = @mouse_ip.tooltip if @mouse_ip.valid?
        view.invalidate
      end

      def onLButtonDown(flags, x, y, view)
        if picked_first_point? && create_edge > 0
          # When the user have picked a start point and then picks another point
          # we create an edge and try to create new faces from that edge.
          # Like the native tool we reset the tool if it created new faces.
          reset_tool
        else
          # If no face was created we let the user chain new edges to the last
          # input point.
          @picked_first_ip.copy!(@mouse_ip)
        end

        update_ui
        view.invalidate
      end

      # Here we have hard coded a special ID for the pencil cursor in SketchUp.
      # Normally you would use `UI.create_cursor(cursor_path, 0, 0)` instead
      # with your own custom cursor bitmap:
      #
      #   CURSOR_PENCIL = UI.create_cursor(cursor_path, 0, 0)
      #CURSOR_PENCIL = 632
      def onSetCursor
        # Note that `onSetCursor` is called frequently so you should not do much
        # work here. At most you switch between different cursor representing
        # the state of the tool.
        UI.set_cursor(@cursor_id)
      end

      def draw(view)
        draw_preview(view)
        @mouse_ip.draw(view) if @mouse_ip.display?
      end

      def getExtents
        bounds = Geom::BoundingBox.new
        bounds.add(picked_points)
        bounds
      end

      private

      def update_ui
        if picked_first_point?
          Sketchup.status_text = 'Select end point.'
        else
          Sketchup.status_text = 'Select start point.'
        end
      end

      def reset_tool
        @picked_first_ip.clear
        update_ui
      end

      def picked_first_point?
        @picked_first_ip.valid?
      end

      def picked_points
        points = []
        points << @picked_first_ip.position if picked_first_point?
        points << @mouse_ip.position if @mouse_ip.valid?
        points
      end

      def draw_preview(view)
          return unless @mouse_ip.valid?
          # se tem o primeiro ponto, então o inicio parte dele
          # se não, o inicio parte do mouse_ip

          # se tem o primeiro ponto, então o fim parte do mouse_ip
          # se não, o fim parte do mouse_ip + 10,10

  pt1 = @picked_first_ip.valid? ? @picked_first_ip.position : @mouse_ip.position
  pt2 = @picked_first_ip.valid? ? @mouse_ip.position : pt1.offset(Geom::Vector3d.new(10, 10, 0))

  # Cria um retângulo no plano Z com base em dois pontos opostos
  vec_x = Geom::Vector3d.new(pt2.x - pt1.x, 0, 0)
  vec_y = Geom::Vector3d.new(0, pt2.y - pt1.y, 0)

  corner1 = pt1
  corner2 = pt1.offset(vec_x)
  corner3 = pt2
  corner4 = pt1.offset(vec_y)

  rectangle = [corner1, corner2, corner3, corner4, corner1]

  view.line_stipple = ''
  view.line_width = 2
  view.drawing_color = 'blue'
  view.draw(GL_LINE_STRIP, rectangle)

  #@first_ip.draw(view)
  @mouse_ip.draw(view)
      end

      # Returns the number of created faces.
      def create_edge
        model = Sketchup.active_model
        model.start_operation('Edge', true)
        edge = model.active_entities.add_line(picked_points)
        num_faces = edge.find_faces || 0 # API returns nil instead of 0.
        model.commit_operation

        num_faces
      end
    end # class CabinetBoxTool
  end # module ModulosMarcenaria
end # module HamirTools
