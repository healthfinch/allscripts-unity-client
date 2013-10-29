require "date"
require "tzinfo"

module AllscriptsUnityClient
  class Timezone
    attr_accessor :tzinfo

    def initialize(zone_identifier)
      raise ArgumentError, "zone_identifier can not be nil" if zone_identifier.nil?

      @tzinfo = TZInfo::Timezone.get(zone_identifier)
    end

    # Use TZInfo to convert a given UTC datetime into
    # a local
    def local_to_utc(datetime)
      convert_with_timezone(:local_to_utc, datetime)
    end

    def utc_to_local(datetime = nil)
      convert_with_timezone(:utc_to_local, datetime)
    end

    private

    # Direction can be :utc_to_local or :local_to_utc
    def convert_with_timezone(direction, datetime = nil)
      if datetime.nil?
        return nil
      end

      # Dates have no time information and so timezone conversion
      # doesn't make sense. Just return the date in this case.
      if datetime.instance_of?(Date)
        return datetime
      end

      if datetime.instance_of?(String)
        datetime = DateTime.parse(datetime.to_s)
      end

      is_datetime = datetime.instance_of?(DateTime)

      if direction == :local_to_utc
        if is_datetime
          # DateTime can do UTC conversions reliably, so use that instead of
          # TZInfo
          datetime = datetime.new_offset(0)
        else
          datetime = @tzinfo.local_to_utc(datetime)
        end

        if is_datetime
          # Convert to a DateTime with a UTC offset
          datetime = DateTime.parse("#{datetime.strftime("%FT%T")}Z")
        end
      end

      if direction == :utc_to_local
        datetime = @tzinfo.utc_to_local(datetime)

        if is_datetime
          # Convert to a DateTime with the correct timezone offset
          datetime = DateTime.parse(iso8601_with_offset(datetime))
        end
      end

      return datetime
    end

    # TZInfo does not correctly update a DateTime's
    # offset, so we manually format a ISO8601 with
    # the correct format
    def iso8601_with_offset(datetime)
      if datetime.nil?
        return nil
      end

      offset = @tzinfo.current_period.utc_offset
      negative_offset = false
      datetime_string = datetime.strftime("%FT%T")

      if offset < 0
        offset *= -1
        negative_offset = true
      end

      if offset == 0
        offset_string = "Z"
      else
        offset_string = Time.at(offset).utc.strftime("%H:%M")
        offset_string = "-" + offset_string if negative_offset
        offset_string = "+" + offset_string unless negative_offset
      end

      "#{datetime_string}#{offset_string}"
    end
  end
end