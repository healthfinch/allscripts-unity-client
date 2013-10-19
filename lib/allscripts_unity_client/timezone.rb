require "date"
require "tzinfo"

module AllscriptsUnityClient
  class Timezone
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

      is_date = datetime.instance_of?(Date)
      is_time = datetime.instance_of?(Time)
      datetime = DateTime.parse(datetime.to_s)

      if direction == :local_to_utc
        datetime = @tzinfo.local_to_utc(datetime)

        # Convert to a DateTime with a UTC offset
        datetime = DateTime.parse("#{datetime.strftime("%FT%T")}Z")
      end

      if direction == :utc_to_local
        datetime = @tzinfo.utc_to_local(datetime)

        # Convert to a DateTime with the correct timezone offset
        datetime = DateTime.parse(iso8601_with_offset(datetime))
      end

      return datetime.to_time if is_time
      return datetime.to_date if is_date
      return datetime
    end

    # TZInfo does not correctly update a DateTime's
    # offset, so we manually format the ISO8601 with
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
        # ISO8601 allows Z to be used instead of +00:00 for
        # UTC. Native Ruby Date#iso8601 uses +00:00. It doesn't
        # really matter, both are valid.
        offset_string = "Z"
      else
        offset_string = Time.at(offset).utc.strftime("%H:%M")
        offset_string = "-" + offset_string if negative_offset
      end

      "#{datetime_string}#{offset_string}"
    end
  end
end